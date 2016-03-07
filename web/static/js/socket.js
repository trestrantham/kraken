import {Socket} from "phoenix"

let userID = $("meta[name='id']").attr('content');
let userToken = $("meta[name='token']").attr('content');
let socket = new Socket("/live", {params: {token: userToken}})

socket.connect()

var channel = socket.channel(`users:${userID}`);

channel.join()
  .receive("ok", () => {
  })
  .receive("error", () => {
    // Set "connection error" class and/or status
  })

export default channel
