namespace: Integrations.hcm202105_demo
flow:
  name: deploy_aos
  inputs:
    - target_host: needtoenterip
    - target_host_username: root
    - target_host_password:
        default: Cloud_1234
        sensitive: true
  workflow:
    - install_postgres:
        do:
          Integrations.demo.aos.software.install_postgres:
            - username: '${target_host_username}'
            - password:
                value: '${target_host_password}'
                sensitive: true
            - tomcat_host: '${target_host}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: install_java
    - install_java:
        do:
          Integrations.demo.aos.software.install_java:
            - username: '${target_host_username}'
            - password:
                value: '${target_host_password}'
                sensitive: true
            - tomcat_host: '${target_host}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: install_tomcat
    - install_tomcat:
        do:
          Integrations.demo.aos.software.install_tomcat:
            - username: '${target_host_username}'
            - password:
                value: '${target_host_password}'
                sensitive: true
            - tomcat_host: '${target_host}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: install_aos
    - install_aos:
        do:
          io.cloudslang.demo.aos.install_aos:
            - username: '${target_host_username}'
            - password:
                value: '${target_host_password}'
                sensitive: true
            - tomcat_host: '${target_host}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      install_postgres:
        x: 100
        'y': 150
      install_java:
        x: 400
        'y': 150
      install_tomcat:
        x: 700
        'y': 150
      install_aos:
        x: 1000
        'y': 150
        navigate:
          0b46ce8b-2f30-e065-7e6f-4b17766623d8:
            targetId: 747a0cc6-af6f-07f8-0e03-02dfa0f14863
            port: SUCCESS
    results:
      SUCCESS:
        747a0cc6-af6f-07f8-0e03-02dfa0f14863:
          x: 1300
          'y': 150
