// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket"


import React from "react"
import ReactDOM from "react-dom"
import { render } from "react-dom"

let titleize = require("underscore.string/titleize");

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
          this.state.connections.map(function(connection) {
            return <Connection name={connection["name"]} state={connection["state"]} />
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
        console.log(`Succesfully joined the connections channel.`)
        channel.push("ping", {})
      })
      .receive("error", () => { console.log(`Unable to join the connections channel.`) })
    channel.on("update", payload => {
      this.setState({
        connectionState: titleize(payload.state),
        message: payload.message
      })
    })
  },
  getInitialState() {
    return {
      channel: socket.channel(`connections:${this.props.name}`),
      name: titleize(this.props.name),
      connectionState: this.props.state,
      message: "steps, weight"
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
                <a className="btn btn-primary" href={`/connection/${this.props.name}`}>
                  Connected
                </a>
              );
            case "available":
              return(
                <a className="btn btn-primary" href={`/connection/${this.props.name.toLowerCase()}`}>
                  Connect
                </a>
              );
            case "expired":
              return(
                <a className="btn btn-primary" href={`/connection/${this.props.name}`}>
                  Reconnect
                </a>
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

render(<Connections />, document.getElementById("connections"))
