import requests
from bs4 import BeautifulSoup

def parse(plugin_name):
    URL = f'https://wordpress.org/plugins/{plugin_name.strip()}'
    try:
        page = requests.get(URL)
        page.raise_for_status()  # Raise an exception for HTTP errors
    except requests.exceptions.RequestException as e:
        return f"Network Error for {plugin_name}!"

    soup = BeautifulSoup(page.content, "html.parser")

    try:
        div_contents = soup.find("div", class_="widget plugin-meta")
        li_contents = div_contents.find_all("li")
    except AttributeError:
        return f"Plugin {plugin_name} does not exist!"

    for item in li_contents:
        if "Active installations" in item.text:
            ad = item.find("strong")
            return f"{plugin_name.strip()}: {ad.text}"
    return f"Active installations info not found for {plugin_name}."

if __name__ == "__main__":
    import sys
    if len(sys.argv) != 2:
        print("Usage: python script.py <file_with_plugin_names>")
    else:
        file_path = sys.argv[1]

        try:
            with open(file_path, "r") as file:
                plugin_names = file.readlines()
            
            for plugin_name in plugin_names:
                if plugin_name.strip():  # Skip empty lines
                    print(parse(plugin_name))
        except FileNotFoundError:
            print(f"File {file_path} not found!")
        except Exception as e:
            print(f"An error occurred: {e}")
