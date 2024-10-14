import os
import requests
from bs4 import BeautifulSoup
import random
import subprocess

# Function to parse the plugin page for active installations
def parse(plugin_name):
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
            return convert_installations(ad.text)

# Function to convert installation text (e.g., "10+ million") to an integer
def convert_installations(install_text):
    install_text = install_text.replace(',', '').replace('+', '').strip().lower()
    
    if "million" in install_text:
        return int(float(install_text.split()[0]) * 1_000_000)
    elif "thousand" in install_text:
        return int(float(install_text.split()[0]) * 1_000)
    elif install_text.isdigit():
        return int(install_text)
    else:
        return 0

# Function to extract random plugins from the file
def get_random_plugins(file_path, count=3):
    try:
        with open(file_path, 'r') as file:
            plugins = file.read().splitlines()
            # Adjust the count if it's greater than the number of available plugins
            if count > len(plugins):
                count = len(plugins)
            return random.sample(plugins, count)
    except FileNotFoundError:
        print("File not found!")
        return []

# Function to download plugin using SVN
def download_plugin(plugin_name):
    svn_url = f"https://plugins.svn.wordpress.org/{plugin_name}/trunk/"
    plugin_dir = os.path.join("extracted_plugins", plugin_name)
    
    # Create directory for plugin if it doesn't exist
    os.makedirs(plugin_dir, exist_ok=True)
    
    # Checkout the plugin's latest version from SVN
    result = subprocess.run(["svn", "checkout", svn_url, plugin_dir], capture_output=True, text=True)
    
    if result.returncode == 0:
        print(f"Downloaded the latest version of {plugin_name} to {plugin_dir}")
    else:
        print(f"Failed to download {plugin_name}. Error: {result.stderr}")

if __name__ == "__main__":
    # Check if the plugin.txt file exists
    plugin_file = "plugin.txt"
    if not os.path.isfile(plugin_file):
        print("File plugin.txt not found!")
        exit(1)
    
    # Create the extracted_plugins directory if it doesn't exist
    os.makedirs("extracted_plugins", exist_ok=True)
    
    # Get a random number of plugin names from the plugin.txt file
    total_plugins = 19394  # You can set this to your desired count
    random_plugins = get_random_plugins(plugin_file, total_plugins)
    
    if random_plugins:
        for plugin in random_plugins:
            installations = parse(plugin)
            # Check if the result is a number and proceed only if valid
            if isinstance(installations, int) and (1000 <= installations <= 100_000_000):
                print(f"Plugin: {plugin}, Active Installations: {installations}")
                # Download the plugin if it has between 1,000 and 100,000,000 installations
                download_plugin(plugin)
            else:
                print(f"Skipping {plugin} (Installations: {installations})")
    else:
        print("No plugins found to download!")
