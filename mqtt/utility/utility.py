import yaml

def readYamlFile(path):
  with open(path, "r") as f:
      try:
          yamlData = yaml.load(f, Loader=yaml.FullLoader)
          return yamlData
      except yaml.YAMLError as exc:
          print(exc)
