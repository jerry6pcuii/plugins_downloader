import os
import random
import subprocess
import requests
from bs4 import BeautifulSoup

def parse(plugin_name):
    """
    Parses the WordPress plugin page to check for the number of active installations.
    """
    URL = 'https://wordpress.org/plugins/' + plugin_name
    try:
        page = requests.get(URL)
    except requests.exceptions.RequestException:
        return "Network Error!"
    
    soup = BeautifulSoup(page.content, "html.parser")
    
    try:
        div_contents = soup.find("div", class_="widget plugin-meta")
        li_contents = div_contents.find_all("li")
    except AttributeError:
        return "Not Exists!"
    
    for item in li_contents:
        if "Active installations" in item.text:
            ad = item.find("strong")
            active_installs = ad.text.replace(',', '')  # Remove commas for parsing
            
            # Check for 'million' or 'billion' and convert accordingly
            if 'million' in active_installs:
                active_installs = float(active_installs.replace(' million', '')) * 1_000_000
            elif 'billion' in active_installs:
                active_installs = float(active_installs.replace(' billion', '')) * 1_000_000_000
            elif 'K' in active_installs:  # Check for installs in the 'K' range
                active_installs = float(active_installs.replace('K', '')) * 1_000
            elif '+' in active_installs:
                active_installs = int(active_installs.replace('+', ''))
            
            try:
                return int(active_installs)
            except ValueError:
                return 0

def get_plugins_from_file(file_path):
    """
    Reads the plugin names from a given file and returns a list of plugin names.
    """
    try:
        with open(file_path, 'r') as file:
            plugins = file.read().splitlines()
            return plugins
    except FileNotFoundError:
        print("File not found!")
        return []

def download_plugin(plugin_name):
    """
    Downloads the specified plugin from the WordPress SVN repository.
    """
    svn_url = f"https://plugins.svn.wordpress.org/{plugin_name}/trunk/"
    os.makedirs(plugin_name, exist_ok=True)
    os.chdir(plugin_name)
    subprocess.run(["svn", "checkout", svn_url, "."], check=True)
    print(f"Downloaded the latest version of {plugin_name} to {os.getcwd()}")
    os.chdir("..")

def main():
    # Check if the plugin.txt file exists
    file_path = 'plugin.txt'
    if not os.path.isfile(file_path):
        print("File plugin.txt not found!")
        return

    # Create the extracted_plugins directory if it doesn't exist
    os.makedirs("extracted_plugins", exist_ok=True)

    # Read plugin names
    plugins = get_plugins_from_file(file_path)

    # Randomly select 3 plugins from the list
    if plugins:
        selected_plugins = random.sample(plugins, 3000)
        os.chdir("extracted_plugins")

        # Process each plugin
        for plugin in selected_plugins:
            active_installs = parse(plugin)

            if isinstance(active_installs, int) and active_installs >= 1000:
                print(f"{plugin} has {active_installs} active installations. Proceeding to download...")
                download_plugin(plugin)
            else:
                print(f"{plugin} has insufficient active installations: {active_installs}. Skipping download.")
    else:
        print("No plugins found in the file!")

if __name__ == "__main__":
    main()
