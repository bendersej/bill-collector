# 🤖 Bill Collector 🤖

## What is it?

An automation to collect bills automatically **without giving away any access credentials**.

Multiple providers, such as `DigitalOcean` do not offer an easy way to retrieve bills.

Some online services offer to automate the collection of bills, however they require to provide the credentials.

---

![Levelsio Tweet](https://beautiful-space.fra1.cdn.digitaloceanspaces.com/bill-collector/tweet.png)

_[Source](https://twitter.com/levelsio/status/1325076943495188481)_

---

## Show me!

_An example with DigitalOcean, the first provider to be supported_

### Run the automation

_Note that the command-line is not the only option, see the other option below_

https://user-images.githubusercontent.com/10613140/144981442-05dec750-8108-4904-9fa8-9388d739ec13.mp4

### Login (handover)

https://user-images.githubusercontent.com/10613140/144982845-b7eb40c4-a080-450b-a6ea-1566d10eabb3.mp4

### Choose the bills to collect

https://user-images.githubusercontent.com/10613140/144982395-3784e654-01ee-4bc4-ab9f-d8ba5d3bfbd5.mp4

## Supported Providers

- [DigitalOcean](https://www.digitalocean.com/)
- [Pipedrive](https://www.pipedrive.com)
- [Namecheap](https://www.namecheap.com/)
- Your provider: **via Pull Request or Issue**

# How to use the Bill Collector

## Via Command-Line (for technical users)

_Prerequisite_:

- [RCC](https://github.com/robocorp/rcc)

Place yourself at the root of this folder and run the following command:

```bash
rcc run
```

## Via User-Interface (for technical and non-technical users)

_Prerequisites_:

- [A Robocorp account](https://robocorp.com) – necessary to download the assistant, available under the free plan without needing to provide a credit card
- [Robocorp Assistant](https://robocorp.com/docs/control-room/configuring-assistants/installation)

Once downloaded and installed, click on _Install a community assistant_ and paste in the URL of this repository: `https://github.com/bendersej/bill-collector`.

## Contributing

### Via Pull Request

Feel free to open a new pull request with the added provider

### Via Issue

If you don't have the skills or the time, feel free to open an Issue with the provider you'd like to be supported.
**Note that you should provide an access (username/password) to help with the development**
