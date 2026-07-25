[NAV\\
 ![](https://docs.wago.io/images/navbar-cad8cdcb.png)](https://docs.wago.io/#)

![](https://docs.wago.io/images/logo-254d6f56.png)

- [Introduction](https://docs.wago.io/#introduction)
- [Authentication](https://docs.wago.io/#authentication)
- [BigWigs packager](https://docs.wago.io/#bigwigs-packager)  - [Adding the Wago Project ID](https://docs.wago.io/#adding-the-wago-project-id)
  - [GitHub actions](https://docs.wago.io/#github-actions)
  - [Running the packager](https://docs.wago.io/#running-the-packager)
- [Manual API integration](https://docs.wago.io/#manual-api-integration)  - [Prepare the metadata](https://docs.wago.io/#prepare-the-metadata)
  - [Sending the upload request](https://docs.wago.io/#sending-the-upload-request)

- [Documentation Powered by Slate](https://github.com/slatedocs/slate)

# Introduction

Welcome to the Wago documentation.

# Authentication

Wago Addons uses API keys to allow access to the API.
You can generate a new API key at our [developer portal](https://addons.wago.io/account/apikeys).

Wago Addons expects for the API key to be included in all API requests to the server in a header that looks like the following:

`Authorization: Bearer IAmAKey`

# BigWigs packager

The easiest way to automate releasing your addon to Wago Addons is using the [BigWigs packager](https://github.com/BigWigsMods/packager).
It's an extremely handy tool that helps you with even more automation than just releases, please visit their documentation to get started.
Once you're set up with the packager adding Wago as a release target is incredibly easy.

## Adding the Wago Project ID

> Add the following line anywhere in your .toc file.

```
Copy to Clipboard
## X-Wago-ID: as3Dfg57
```

As a first step you need to add your addon's project id to your `.toc` file. You can find this ID on your [developer dashboard](https://addons.wago.io/developers),
it's printed directly beneath your addon's name and should be an 8-digit alpha numeric string.

## GitHub actions

```
Copy to Clipboard
  - name: Create Package
    uses: BigWigsMods/packager@master
    env:
      # This section might already create other env variables, just append the WAGO_API_TOKEN to these
      WAGO_API_TOKEN: ${{ secrets.WAGO_API_TOKEN }}
```

If you are using the packager with GitHub action please add a secret to your GitHub repository settings that you call
`WAGO_API_TOKEN`. Once you've done that edit your GitHub Actions workflow file to export the necessary env variable.
Check out the attached code example.

That's it, now upon the next push to your repository the packager will start publishing releases to Wago Addons as well!

## Running the packager

```
Copy to Clipboard
export WAGO_API_TOKEN="IAmAKey"
```

In order to access your addon project trough our API you need to configure the packager to use your [API key](https://addons.wago.io/account/apikeys).
To do that you simply export the `WAGO_API_TOKEN` environment variable containing the key.

# Manual API integration

In case you are not using the packager and want to automate the upload of your releases via API Wago Addons offers a
convenient multipart form API for you to use.

## Prepare the metadata

```
Copy to Clipboard
{
  "label": "1.2.3", // replace with your release name
  "stability": "stable", // one of: stable, beta, alpha
  "changelog": "#Changelog...", // your release changelog as a markdown string

  // You have to add at least one of the following game properties.
  "supported_retail_patch": "9.1.0",
  "supported_wotlk_patch": "3.4.0",
  "supported_bc_patch": "2.5.1",
  "supported_classic_patch": "1.13.7"
}
```

The API expects release metadata to be a JSON string in one of the properties. The JSON object looks like show in the
code example.

You can find all available patch versions using our API at [https://addons.wago.io/api/data/game](https://addons.wago.io/api/data/game).
Generally we follow Blizzard's SemVer versioning of the WoW client.

With the upcoming addition of multi interface support we already allow to publish addons to target all the game flavors.
You can find a detailed explanation of this [here](https://github.com/Stanzilla/WoWUIBugs/issues/68).

However, if you prefer to publish separate artifacts for the different game flavors please send a separate release
upload request per targeted client.

## Sending the upload request

### HTTP Request

```
Copy to Clipboard
  curl -f -X POST \
      -F "metadata=$METADATASTRING \
      -F "file=@<path-to-file>" \
      -H "authorization: Bearer $WAGO_API_KEY"
      -H "accept: application/json" \
      https://addons.wago.io/api/projects/<project id>/version
```

`POST https://addons.wago.io/api/projects/<project id>/version`

### Headers

| Name | Value | Description |
| --- | --- | --- |
| Authorization | Your Wago Addons API token | You can find your token [here](https://addons.wago.io/account/apikeys). |
| Accept | application/json | This should be set to your preferred response Content-Type, typically `application/json`. |

### Parameters

| Name | Value |
| --- | --- |
| file | The release file |
| metadata | The JSON object described above as string |