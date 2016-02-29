import "phoenix_html"

import socket from "./socket"

import React from "react"
import ReactDOM from "react-dom"
import { render } from "react-dom"

let titleize = require("underscore.string/titleize");
let humanize = require("underscore.string/humanize");

let Connections = React.createClass({
  getInitialState: function() {
    return {
      connections: []
    }
  },
  componentDidMount: function() {
    var parentNode = ReactDOM.findDOMNode(this).parentNode;
    var connectionAttributes = {};

    [].slice.call(parentNode.attributes).forEach(function (attribute) {
      if (attribute.name.match(/^data-connections/)) {
        var name = attribute.name.substr(5);

        if ("connections" == name) {
          this.setState({ connections: JSON.parse(attribute.value) });
        }

        parentNode.removeAttribute(attribute.name);
      }
    }, this);
  },
  render() {
    return(
      <div className="row">
        {
          this.state.connections.map(function(connection, index) {
            return <Connection key={index} name={connection["name"]} state={connection["state"]} />
          })
        }
      </div>
    )
  }
})

let Connection = React.createClass({
  configureChannel(channel) {
    channel.join()
      .receive("ok", () => {
        console.log("Successfully joined the connections channel.")
        channel.push("loaded", {"provider": this.state.name.toLowerCase()})
      })
      .receive("error", () => {
        console.log("Unable to join the connections channel.")
      })

    channel.on("update", payload => {
      console.log(payload);
      this.setState({
        connectionState: payload.state,
        message: payload.message
      })
    })
  },
  getInitialState() {
    return {
      channel: socket.channel(`connections:${this.props.name}`),
      name: titleize(humanize(this.props.name)),
      connectionState: this.props.state,
      message: this.props.message
    }
  },
  componentDidMount() {
    this.configureChannel(this.state.channel)
  },
  render() {
    return(
      <div className="col-md-4">
        <div className="card indigo">
          <div className="card-header">
            <div className="card-title">
              {this.state.connectionState}
              <i className="material-icons"></i>
            </div>
            <i className="fa fa-anchor"></i>
          </div>
          <div className="card-content">{this.state.name}</div>
          <div className="card-footer">
            <ConnectionAction
              name={this.state.name}
              connectionState={this.state.connectionState}
              message={this.state.message}
            />
          </div>
        </div>
      </div>
    )
  }
})

let ConnectionAction = React.createClass({
  render() {
    return(
      <div>
        {(() => {
          switch (this.props.connectionState) {
            case "connected":
              return(
                <a className="btn btn-primary" href={`/connection/${this.props.name.toLowerCase()}`}>
                  Connected
                </a>
              );
            case "available":
              return(
                <a className="btn btn-primary" href={`/connection/${this.props.name.toLowerCase()}`}>
                  Connect
                </a>
              );
            case "disconnected":
              return(
                <a className="btn btn-primary" href={`/connection/${this.props.name.toLowerCase()}`}>
                  Reconnect
                </a>
              );
            case "coming_soon":
              return(
                <span>Coming Soon</span>
              );
            case "syncing":
              return(
                <a className="btn btn-primary" href={`/connection/${this.props.name}`}>
                  Syncing
                </a>
              );
          }
        })()}
      </div>
    )
  }
})

if (document.getElementById("connections")) {
  render(<Connections />, document.getElementById("connections"))
}
