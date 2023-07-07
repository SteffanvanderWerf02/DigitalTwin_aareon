# Aareon Webhook



## Nodig om de Webhook te runnen:

[Nodejs 16.x]( https://nodejs.dev/)

[pnpm](https://pnpm.io/installation)

[ngrok] `choco install ngrok`


## Gebruik voor localhost: 

Installeer packages: `pnpm i`

Run dev environment: `pnpm run dev`

setup authtoken: `ngrok config add-authtoken <token>`

run ngrok: `ngrok http 5000`

copy forwarding url into webhook destination

