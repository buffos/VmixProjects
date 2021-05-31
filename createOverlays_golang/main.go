package main

import (
	"errors"
	"fmt"
	"image"
	"image/color"
	"image/png"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"strconv"
	"strings"

	"github.com/antchfx/xmlquery"
	"github.com/golang/freetype/truetype"
	"golang.org/x/image/font"
	"golang.org/x/image/math/fixed"
)

var (
	imageX           = 1920
	imageY           = 1080
	img              = image.NewRGBA(image.Rect(0, 0, imageX, imageY))
	col              = color.Black
	font_size_index  = 160
	font_size_title  = 30
	max_camera_index = 3
	utf8FontFile     = "arial.ttf"
	spacing          = float64(1.5)
	dpi              = float64(72)
)

func main() {
	args := os.Args[1:]
	if len(args) != 3 {
		fmt.Println("Syntax: overlay preview|active preset.vmix noOfCameras")
		os.Exit(1)
	}

	if (args[0] != "active") && (args[0] != "preview") {
		fmt.Println("First argument should be active or preview")
		os.Exit(2)
	}

	file, err := os.Open(args[1])
	if errors.Is(err, os.ErrNotExist) {
		fmt.Println("Preset file does not exist")
		os.Exit(3)
	}
	defer file.Close()

	noOfCameras, err := strconv.Atoi(args[2])
	if err == nil {
		max_camera_index = noOfCameras
	}

	// Encode as PNG.
	f, err := os.Create("image.png")
	if err != nil {
		panic(err)
	}
	defer f.Close()

	createOverlayFor(args[0], args[1])
	png.Encode(f, img)
}

// HLine draws a horizontal line
func drawHLine(x1, y, x2 int) {
	for ; x1 <= x2; x1++ {
		img.Set(x1, y, col)
	}
}

// VLine draws a vertical line
func drawVLine(x, y1, y2 int) {
	for ; y1 <= y2; y1++ {
		img.Set(x, y1, col)
	}
}

func drawRectangle(x1, y1, x2, y2 int) {
	drawHLine(x1, y1, x2)
	drawHLine(x1, y2, x2)
	drawVLine(x1, y1, y2)
	drawVLine(x2, y1, y2)
}

func drawText(x, y int, label string, size int) {
	point := fixed.Point26_6{X: fixed.Int26_6(x * 64), Y: fixed.Int26_6(y * 64)}
	b, err := ioutil.ReadFile(utf8FontFile)
	if err != nil {
		fmt.Println(err)
		return
	}
	//Parse font file
	ttf, err := truetype.Parse(b)
	if err != nil {
		log.Println(err)
		return
	}

	//Create Font.Face from font
	face := truetype.NewFace(ttf, &truetype.Options{
		Size:    float64(size),
		DPI:     dpi,
		Hinting: font.HintingNone,
	})

	d := &font.Drawer{
		Dst:  img,
		Src:  image.NewUniform(col),
		Face: face,
		Dot:  point,
	}
	d.DrawString(label)
}

func getVmixApi() *xmlquery.Node {
	resp, err := http.Get("http://localhost:8088/api")
	if err != nil {
		fmt.Println("Vmix is not running")
		panic(err)
	}
	body, err := ioutil.ReadAll(resp.Body)
	sb := string(body)
	root, err := xmlquery.Parse(strings.NewReader(sb))
	if err != nil {
		panic(err)
	}
	return root
}

func getTargetInput(target string) map[string]interface{} {
	vmixApi := getVmixApi()
	targetIndex := xmlquery.FindOne(vmixApi, fmt.Sprintf("//%s", target)).InnerText()
	targetInput := xmlquery.FindOne(vmixApi, fmt.Sprintf("//input[@number='%s']", targetIndex))
	overlays := xmlquery.Find(targetInput, fmt.Sprintf("//overlay"))
	result := map[string]interface{}{
		"title":    targetInput.SelectAttr("title"),
		"index":    targetIndex,
		"overlays": overlays,
		"api":      vmixApi,
	}
	return result
}

func getClippingForInput(title string, preset string) [][4]float64 {
	clipping := make([][4]float64, 0)
	f, err := os.Open(preset)
	if err != nil {
		panic(err)
	}
	defer f.Close()
	vmix, err := xmlquery.Parse(f)
	if err != nil {
		panic(err)
	}
	result := xmlquery.FindOne(vmix, fmt.Sprintf("//Input[@Title='%s']", title))
	xmlPositions := strings.Replace(result.SelectAttr("PositionsExtended"), "utf-16", "utf-8", 1)
	positions, err := xmlquery.Parse(strings.NewReader(xmlPositions))
	if err != nil {
		panic(err)
	}
	layers := xmlquery.Find(positions, fmt.Sprintf("//MatrixPosition"))
	for i := 0; i < len(layers); i++ {
		floats := xmlquery.Find(layers[i], ".//Clipping/float")
		if len(floats) > 0 {
			realFloats := [4]float64{}
			for j := 0; j < 4; j++ {
				realFloats[j], err = strconv.ParseFloat(floats[j].InnerText(), 64)
			}
			clipping = append(clipping, realFloats)
		} else {
			realFloats := [4]float64{0.0, 0.0, 1.0, 1.0}
			clipping = append(clipping, realFloats)
		}
	}
	return clipping
}

func drawBox(title string, index int, pan_zoom [4]float64, clip_array [4]float64, borderColor string) {
	pan_x, pan_y, zoom_x, zoom_y := pan_zoom[0], pan_zoom[1], pan_zoom[2], pan_zoom[3]
	center_x := (pan_x + 1.0) * float64(imageX) / 2.0
	center_y := float64(imageY) - (pan_y+1.0)*float64(imageY)/2.0

	dx := float64(imageX) / 2.
	dy := float64(imageY) / 2.

	start_x := center_x - (dx-clip_array[0]*float64(imageX))*zoom_x
	start_y := center_y - (dy-clip_array[1]*float64(imageY))*zoom_y

	end_x := center_x - (dx-clip_array[2]*float64(imageX))*zoom_x
	end_y := center_y - (dy-clip_array[3]*float64(imageY))*zoom_y

	drawRectangle(int(start_x), int(start_y), int(end_x), int(end_y))
	drawText(int(center_x)-font_size_index/4, int(end_y)-font_size_index, strconv.Itoa(index), font_size_index)
	drawText(int(center_x)-len(title)*font_size_title/4, int(end_y)-font_size_title, title, font_size_title)
}

func getPanZoomFromOverlay(overlay *xmlquery.Node) ([4]float64, error) {
	var panX, panY, zoomX, zoomY float64

	v, err := xmlquery.Query(overlay, "//position")
	if err != nil {
		return [4]float64{}, errors.New("no position element")
	}

	v, err = xmlquery.Query(overlay, "//position/@panX")
	if v == nil {
		panX = 0.0
	} else {
		panX, _ = strconv.ParseFloat(v.InnerText(), 64)
	}
	v, err = xmlquery.Query(overlay, "//position/@panY")

	if v == nil {
		panY = 0.0
	} else {
		panY, _ = strconv.ParseFloat(v.InnerText(), 64)
	}
	v, err = xmlquery.Query(overlay, "//position/@zoomX")
	if v == nil {
		zoomX = 1.0
	} else {
		zoomX, _ = strconv.ParseFloat(v.InnerText(), 64)
	}
	v, err = xmlquery.Query(overlay, "//position/@zoomY")
	if v == nil {
		zoomY = 1.0
	} else {
		zoomY, _ = strconv.ParseFloat(v.InnerText(), 64)
	}

	return [4]float64{panX, panY, zoomX, zoomY}, nil
}

func isOverlayCamera(overlay *xmlquery.Node, api *xmlquery.Node) bool {
	key := overlay.SelectAttr("key")
	vmixInput := xmlquery.FindOne(api, fmt.Sprintf("//input[@key='%s']", key))
	number, _ := strconv.ParseInt(vmixInput.SelectAttr("number"), 10, 32)
	return number <= int64(max_camera_index)
}

func getOverlayTitle(overlay *xmlquery.Node, api *xmlquery.Node) string {
	key := overlay.SelectAttr("key")
	vmixInput := xmlquery.FindOne(api, fmt.Sprintf("//input[@key='%s']", key))
	return vmixInput.SelectAttr("title")
}

func createOverlayFor(target string, preset string) {
	preview := getTargetInput(target)
	title := fmt.Sprintf("%v", preview["title"])
	api := preview["api"].(*xmlquery.Node)
	crops := getClippingForInput(title, preset)
	overlays := preview["overlays"].([]*xmlquery.Node)

	for _, overlay := range overlays {
		if !isOverlayCamera(overlay, api) {
			continue
		}
		cameraTitle := getOverlayTitle(overlay, api)

		pan_zoom, err := getPanZoomFromOverlay(overlay)
		if err != nil {
			continue
		}
		overlayIndex, _ := strconv.ParseInt(overlay.SelectAttr("index"), 10, 32)
		drawBox(cameraTitle, int(overlayIndex), pan_zoom, crops[overlayIndex+1], "black")
	}
}
