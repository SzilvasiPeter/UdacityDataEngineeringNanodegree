import os
import shutil
import re

from zipfile import ZipFile


def unzip(zipfile, extract_to):
    with ZipFile(zipfile, "r") as zip_file:
        for file in zip_file.namelist():
            # match only for the csv files under the 'Out/' folder
            if not re.search('^Out\/\w+\.csv$', file):
                continue
            
            # create the new destination directory
            if not os.path.exists(extract_to):
                os.makedirs(extract_to)

            filename = os.path.basename(file)

            # copy file without its folder structure
            source = zip_file.open(file)
            target = open(os.path.join(extract_to, filename), "wb")
            with source, target:
                shutil.copyfileobj(source, target)


if __name__ == "__main__":
    zipfile = './bikeshare-dataset.zip'
    extract_to1 = './02CloudDataWarehouse/project-solution/data'
    extract_to1 = './03DataLakehouse/project-solution/data'
    unzip(zipfile, extract_to1)