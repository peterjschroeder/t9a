#!/usr/bin/python
# coding: utf-8

import os, sys
import fitz  # this is pymupdf
import re

def pdf2txt(): 
  for filename in sys.argv[1:]: 
    print('Extract', filename)
    inputfile = filename
    shortName = os.path.splitext(filename)[0]
    outputfile = shortName+".json"
    print('to', outputfile)

    with fitz.open(inputfile) as doc:
      text = ""

      for page in doc:
          text += page.get_text()

      f = open(outputfile, "w")

      text = re.sub(r'”', '"', text)
      text = re.sub(r'[“‟″〃〞«»❞„¨]', '\"', text)
      text = re.sub(r'\},[\ \n]*\]', '}]', text)
      text = re.sub(r'\n', ' ', text)
      text = re.sub(r'\n', ' ', text)
      text = re.sub(r'\n', ' ', text)
      text = re.sub(r'\u00a0', ' ', text)
      text = re.sub(r'[’‘´`˜]', '\'', text)
      text = re.sub(r'[-\-‐‑‒–—⸺⸻―⁃−───]', '-', text)
      text = re.sub(r'  ', ' ', text)
      text = re.sub(r'  ', ' ', text)
      text = re.sub(r'\\', '', text)
      text = re.sub(r' *"', '"', text)
      text = re.sub(r'Temporary page!(.+)$', '', text)
      text = re.sub(r'^(.+){"id":', '{"id":', text)
      text = re.sub(r'([a-zA-Z0-9\u0400-\u04FF\-\+\(\);])"(\.|\ *[\.a-zA-Z\u0400-\u04FF•\)]|, +[0-9a-zA-Z•\u0400-\u04FF])', r'\1&quot;\2', text)

      f.write(text)
      f.close()
      
if __name__ == "__main__":
  pdf2txt()