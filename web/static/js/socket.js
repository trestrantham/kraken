import {Socket} from "phoenix"

let socket = new Socket("/live", {params: {token: window.userToken}})

socket.connect()

var channel = socket.channel(`users:${window.userToken}`);

channel.join()
  .receive("ok", () => {
  })
  .receive("error", () => {
  })

export default channel
