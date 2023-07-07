import sys
sys.path.append('../database')
import database 

def main():
  database.updateRetentionPeriod()

if __name__ == '__main__':
  main()