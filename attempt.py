//For plugins
import requests
import sys
from bs4 import BeatifulSoup

def parse(plugin_name):
    URL = 'https://wordpress.org/plugins'+plugin_name
    try:
        page = requests.get(URL)
    except requests.exceptions.RequestException as e:
        return "Network Error!"

    soup = BeatifulSoup(page.content, "html.parser")

    try:
        div_contents = soup.find("div", class_="widget plugin-meta")
        li_contents = div_contents.find_all("li")
    except AttributeError:
        return "Not Exist!"
    for item in li_contents:
        if "Active installations" in item.txt:
            ad = item.find("strong")
            return ad.text
