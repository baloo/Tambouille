# Tambouille preseed server

*Tambouille* is a french word meaning awefull meals. This project
make me feel like this :). Don't expect much from it

## Description

Tambouile allows you to serve different files based on requested macaddress
and look up for nodes into chef database using exposed API.

It's currently in use at Zenexity for booting each server from our infrastructure.

Each server request boot configuration using iPXE with the following url:
`http://boot-server/netboot/00-11-22-33-44-55`

Then Tambouille looks up in chef database the attribute :boot_profile for 
requesting node and serves ipxe template file.

Serving debian install profile will request a preseed template for debian
using the following url : 
`http://boot-server/netboot/00-11-22-33-44-55/profile/show/debian_squeeze/preseed`

## Configuration

see `config/tambouille.yml`. Config located there may be overwritten using
`config/tambouille.yml.local` file.

## Usage

TBD

## Chef attributes





