[![build](https://github.com/campforce/auto-parts-retail/actions/workflows/build.yml/badge.svg)](https://github.com/campforce/auto-parts-retail/actions/workflows/build.yml)
# Auto Parts Retail App
Salesforce application of auto parts retailer. 🚘🛠⚙️

## Installation

### Requirements
  - Enable Dev Hub in your Org
  - Install Salesforce CLI
  - Install Visual Studio Code
  - Install the Visual Studio Code Salesforce extensions

---

1. Clone this repository:

    ```
    git clone https://github.com/campforce/property-management.git
    cd property-management
    ```

1. Authorize your hub org:

    ```
    sfdx auth:web:login -d -a devhub
    ```

1. Create a scratch org:

    ```
    sfdx force:org:create -s -f config/project-scratch-def.json -a app
    ```

1. Push the app to your scratch org:

    ```
    sfdx force:source:push
    ```

1. Assign the **superuser** permission set to enable super feaures:

    ```
    sfdx force:user:permset:assign -n superuser
    ```

1. Open the scratch org:

    ```
    sfdx force:org:open
    ```
## Contributors
<a href = "https://github.com/campforce/property-management/graphs/contributors">
  <img src = "https://contrib.rocks/image?repo=campforce/auto-parts-retail"/>
</a>
