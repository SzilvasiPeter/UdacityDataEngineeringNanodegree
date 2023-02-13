import os
import shutil
import re

from zipfile import ZipFile


def unzip(zipfile, extract_to):
    with ZipFile(zipfile, "r") as zip_file:
        for file in zip_file.namelist():
            # match only for the csv files under the 'Out/' or 'Data/' folder
            if not (re.search('^Out\/\w+\.csv$', file) or re.search('^Data\/\w+\.csv$', file)):
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
    bikshare_zip = './bikeshare-dataset.zip'
    nycpayroll_zip = './data-nyc-payroll.zip'
    extract_to1 = './02CloudDataWarehouse/project-solution/data'
    extract_to2 = './03DataLakehouse/project-solution/data'
    extract_to3 = './04DataPipeline/project-solution/data'

    unzip(bikshare_zip, extract_to1)
    unzip(bikshare_zip, extract_to2)
    unzip(nycpayroll_zip, extract_to3)