import {Socket} from "phoenix"

let socket = new Socket("/live", {params: {token: window.userToken}})

socket.connect()

export default socket
