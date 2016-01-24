# Web Game Ranking Module
Python web server and web page framework of ranking feature for web games

## Contributors
**Baolin Fan**   
fblhalo@gmail.com   
https://github.com/finmily   
**Zuoming Li**  
zuomingli@uchicago.edu  
https://github.com/aaaeeeo/  

## Description
### Server
Python server developed base on `BaseHTTPServer`
With features:
1. Handle GET and POST request, acquire parameters and response data by json
2. Read specific static file and response to GET request
3. Connect to MySQL with ranking logic and logging
4. Separate config file

## Usage
### Server
Config file: /gamerank/config.py
Setup file: /setup.py  

Server: /gamerank/server.py
```
python3 gamerank/server.py
```

## Project Structure    
```
├── README.md
├── database
│   ├── gamerank_2016-01-10.sql
│   └── gamerank_2016-01-10_withtestdata.sql
├── gamerank
│   ├── __init__.py
│   ├── config.py
│   ├── modules
│   │   ├── __init__.py
│   │   ├── controller.py
│   │   ├── dbhandler.py
│   │   ├── httphandler.py
│   │   ├── model.py
│   │   └── pathhelper.py
│   ├── pages
│   └── server.py
├── setup.py
└── tests
    ├── __init__.py
    └── gamerank_tests.py
```


