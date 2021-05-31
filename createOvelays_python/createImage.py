#!/bin/bash/python3

from PIL import Image, ImageDraw, ImageFont
import xml.etree.ElementTree as ET
import http.client

imageX = 1920
imageY = 1080

FONT_SIZE_INDEX = 160
FONT_SIZE_TITLE = 30
MAX_CAMERA_INDEX = 3

image = Image.new('RGBA', (imageX, imageY), (255, 255, 255, 0))
draw = ImageDraw.Draw(image)


def get_vmix_api():
    """ Returns an the live XML object of VMIX API

    Returns: xml.etree.ElementTree.Element
    """
    connection = http.client.HTTPConnection("localhost", 8088)
    connection.request("GET", "/api")
    response = connection.getresponse()
    xml = response.read()
    connection.close()

    return ET.fromstring(xml)


def get_target_input(target):
    """ Finds the target input to design the overlay.

    Parameters:
        target (str): The target should be either preview or active.

    Returns:
       object (dict): It contains the title, index of the input, the overlay Elements and the api for later reference if needed
    """
    api = get_vmix_api()
    preview_index = api.find(f'./{target}').text
    preview = api.find(f".//input[@number='{preview_index}']")
    overlays = preview.findall("./overlay")

    return {'title': preview.get('title'), 'index': preview_index, 'overlays': overlays, 'api': api}


def get_clipping_for_input(title, preset):
    """Extracts from the Input (preview or program), based on the title of the input
    the cropping information of each layer. This is done from the preset file.

    Parameters:
        title(str): the title of input (preview or program)
        preset(str): the preset filename

    Returns:
       clipping(float[]): An array with the clipping values for each of the multilayer layers.
    """
    clipping = []
    vmix = ET.parse(preset).getroot()
    result = vmix.find(f'.//Input[@Title="{title}"]')
    positions = ET.fromstring(result.attrib.get('PositionsExtended'))
    for i in range(len(positions)):
        floats = positions.findall(f".//MatrixPosition[{i+1}]/Clipping/float")
        if len(floats) > 0:
            clipping.append(
                [float(floats[0].text),
                 float(floats[1].text),
                 float(floats[2].text),
                 float(floats[3].text)])
        else:
            clipping.append([0, 0, 1, 1])
    return clipping


def draw_box(title, index, pan_zoom, clip_array, border_color=None):
    """ Draws a box with the given pan_zoom information and clipping data.

    Parameters:
        title(str): The title to be printed for the box.
        index(int): The index in the layer stack (+1 since the main layer is also in the cropping list)
        pan_zoom(float[]): [panX, panY, zoomX, zoomY]
        clip_array(float[]): [clipStartX, clipStartY, clipEndX, clipEndY]
        border_color(str): hex value for color (default is black)
    """
    pan_x, pan_y, zoom_x, zoom_y = pan_zoom
    center_x = (pan_x + 1) * imageX / 2
    center_y = imageY - (pan_y + 1) * imageY / 2

    dx = imageX / 2
    dy = imageY / 2

    start_x = center_x - (dx - clip_array[0] * imageX) * zoom_x
    start_y = center_y - (dy - clip_array[1] * imageY) * zoom_y

    end_x = center_x - (dx - clip_array[2] * imageX) * zoom_x
    end_y = center_y - (dy - clip_array[3] * imageY) * zoom_y

    draw.rectangle([start_x, start_y, end_x, end_y],
                   fill=None, outline=border_color)

    # get a font
    fnt = ImageFont.truetype("arial.ttf", FONT_SIZE_INDEX)
    # draw text, full opacity
    draw.text((center_x - FONT_SIZE_INDEX/4, center_y - FONT_SIZE_INDEX / 2), str(index),
              font=fnt, fill=(0, 0, 0, 255))

    fnt = ImageFont.truetype("arial.ttf", FONT_SIZE_TITLE)
    draw.text((center_x - len(title) * FONT_SIZE_TITLE/4, end_y - FONT_SIZE_TITLE), title,
              font=fnt, fill=(0, 0, 0, 255))


def get_pan_zoom_from_overlay(overlay):
    """Extract pan zoom information from the overlay xml Element

    Returns:
        pan_zoom(float[]): [panX, panY, zoomX, zoomY]
    """

    position = overlay.find('./position')
    if position is None:
        return None

    return [float(position.get('panX', 0)), float(position.get('panY', 0)), float(position.get('zoomX', 1)), float(position.get('zoomY', 1))]


def is_overlay_a_camera(overlay, api):
    """Check if the overlay is a camera and eligible to draw a box.
    We define in the beginning that the first N inputs are cameras or switchable

    Parameters:
        overlay(xml.etree.ElementTree.Element): The Overlay we want to check
        api(xml.etree.ElementTree.Element): the complete live vmix api
    """
    key = overlay.get('key')
    vmix_input = api.find(f'.//input[@key="{key}"]')
    number = int(vmix_input.get('number'))
    return number <= MAX_CAMERA_INDEX


def get_overlay_title(overlay, api):
    """Get the title of the overlay in the live API

    Parameters:
        overlay(xml.etree.ElementTree.Element): The Overlay we want to check
        api(xml.etree.ElementTree.Element): the complete live vmix api
    """
    key = overlay.get('key')
    vmix_input = api.find(f'.//input[@key="{key}"]')
    title = vmix_input.get('title')
    return title


def create_overlay_for(target, preset):
    """Draw bounding boxes for cameras for the required target

    Parameters:
        target(str): preview or active
        preset(str): the preset .vmix file (with path)
    """
    preview = get_target_input(target)
    title = preview['title']
    api = preview['api']
    crops = get_clipping_for_input(title, preset)

    for overlay in preview['overlays']:
        if not is_overlay_a_camera(overlay, api):
            continue
        camera_title = get_overlay_title(overlay, api)
        pan_zoom = get_pan_zoom_from_overlay(overlay)
        if pan_zoom is not None:
            overlay_index = int(overlay.get('index'))
            draw_box(camera_title, overlay_index, pan_zoom,
                     crops[overlay_index + 1], 'black')


if __name__ == "__main__":
    # use active or preview to create an overlay image for the preview or active input
    create_overlay_for("active", "test.vmix")
    image.save("overlay.png", "PNG")
