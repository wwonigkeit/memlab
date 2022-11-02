
# memlab 1.0

Run memlab in Direktiv on buster

---
- #### Categories: build, development
- #### Image: gcr.io/direktiv/functions/memlab 
- #### License: [Apache-2.0](https://www.apache.org/licenses/LICENSE-2.0)
- #### Issue Tracking: https://github.com/direktiv-apps/memlab/issues
- #### URL: https://github.com/direktiv-apps/memlab
- #### Maintainer: [direktiv.io](https://www.direktiv.io) 
---

## About memlab

This function provides a memlab install on Node.js as a Direktiv function. memlab is a memory leak detector for front-end JS.

Node Version Manager is installed to support LTS versions. The following versions are installed in this function:

- 18.10.0

- 16.17.1

NVM (Node Version Manager) can be used as well to install different versions but it is function wide which means changes are visible to all function calls during the function / container lifetime. If the application is returning plain JSON on standard out it will be used as JSON result in Direktiv. If the application prints other strings to standard out the response will be a plain string. If JSON output is required the application can create and write to a file called output.json. If this file exists, this function uses its contents as return value.
Functions can have a context to persist the node_modules directory across different execution cycles. Unlike Direktiv's regular behaviour to have a new working directory for each execution, the context ensures that it runs in the same directory each time. 

### Example(s)
  #### Function Configuration
```yaml
functions:
- id: memlab
  image: gcr.io/direktiv/functions/memlab:1.0
  type: knative-workflow
```
   #### Basic
```yaml
- id: memlab 
  type: action
  action:
    function: memlab
    input:
      files:
      - name: scenario.js
        data: |
          // initial page load's url
          function url() {
            return "https://www.youtube.com";
          }

          // action where you suspect the memory leak might be happening
          async function action(page) {
            await page.click('[id="video-title-link"]');
          }

          // how to go back to the state before action
          async function back(page) {
            await page.click('[id="logo-icon"]');
          }

          module.exports = { action, back, url };
      commands:
      - command: memlab run --scenario scenario.js
```
   #### Change node version
```yaml
- id: memlab 
  type: action
  action:
    function: memlab
    input:
      node: "16"
      commands:
      - command: node -v
```
   #### Using a context
```yaml
- id: memlab 
  type: action
  action:
    function: memlab
    input: 
      context: memlab-app
      files: 
      - name: scenario.js
        data: |
          // initial page load's url
          function url() {
            return "https://www.youtube.com";
          }

          // action where you suspect the memory leak might be happening
          async function action(page) {
            await page.click('[id="video-title-link"]');
          }

          // how to go back to the state before action
          async function back(page) {
            await page.click('[id="logo-icon"]');
          }

          module.exports = { action, back, url };
      commands:
      - command: npm install uuid
      - command: memlab run --scenario scenario.js  
```
   #### Using Direktiv variable as script
```yaml
- id: memlab 
  type: action
  action:
    function: memlab
    files:
    - key: scenario.js
      scope: workflow
    input:
      commands:
      - command: memlab run --scenario scenario.js      
```

   ### Secrets


*No secrets required*







### Request



#### Request Attributes
[PostParamsBody](#post-params-body)

### Response
  List of executed commands.
#### Reponse Types
    
  

[PostOKBody](#post-o-k-body)
#### Example Reponses
    
```json
[
  {
    "result": "Hello World",
    "success": true
  }
]
```

### Errors
| Type | Description
|------|---------|
| io.direktiv.command.error | Command execution failed |
| io.direktiv.output.error | Template error for output generation of the service |
| io.direktiv.ri.error | Can not create information object from request |


### Types
#### <span id="post-o-k-body"></span> postOKBody

  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| memlab | [][PostOKBodyMemlabItems](#post-o-k-body-memlab-items)| `[]*PostOKBodyMemlabItems` |  | |  |  |


#### <span id="post-o-k-body-memlab-items"></span> postOKBodyMemlabItems

  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| result | [interface{}](#interface)| `interface{}` | ✓ | |  |  |
| success | boolean| `bool` | ✓ | |  |  |


#### <span id="post-params-body"></span> postParamsBody

  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| commands | [][PostParamsBodyCommandsItems](#post-params-body-commands-items)| `[]*PostParamsBodyCommandsItems` |  | `[{"command":"memlab run --scenario scenario.js"}]`| Array of commands. |  |
| context | string| `string` |  | | Direktiv will delete the working directory after each execution. With the context the application can run in a different
directory and commands like npm install will be persistent. If context is not set the "node_module" directory will be deleted
and each execution of the flow uses an empty modules folder. Multiple apps can not share a context. |  |
| files | [][DirektivFile](#direktiv-file)| `[]apps.DirektivFile` |  | | File to create before running commands. |  |
| node | string| `string` |  | `"18.10.0"`| Default node version for the script |  |


#### <span id="post-params-body-commands-items"></span> postParamsBodyCommandsItems

  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| command | string| `string` |  | | Command to run |  |
| continue | boolean| `bool` |  | | Stops excecution if command fails, otherwise proceeds with next command |  |
| print | boolean| `bool` |  | `true`| If set to false the command will not print the full command with arguments to logs. |  |
| silent | boolean| `bool` |  | | If set to false the command will not print output to logs. |  |

 
