import "phoenix_html"

import channel from "./socket"

import React from "react"
import ReactDOM from "react-dom"
import { render } from "react-dom"

let titleize = require("underscore.string/titleize");
let humanize = require("underscore.string/humanize");

let Providers = React.createClass({
  getInitialState() {
    return {
      providers: {}
    }
  },
  componentDidMount() {
    var parentNode = ReactDOM.findDOMNode(this).parentNode;
    var providerAttributes = {};

    [].slice.call(parentNode.attributes).forEach(function (attribute) {
      if (attribute.name.match(/^data-providers/)) {
        var name = attribute.name.substr(5);

        if ("providers" == name) {
          var providerValues = JSON.parse(attribute.value);
          var providers = {};

          $.each(providerValues, function() {
            providers[this.name] = this
          })

          this.setState({ providers: providers });
        }

        parentNode.removeAttribute(attribute.name);
      }
    }, this);

    channel.on("connections:update", payload => {
      providers = $.extend({}, this.state.providers)
      providers[payload.name] = payload

      this.setState({ providers: providers })
    })
  },
  render() {
    return(
      <div className="row">
        {
          $.map(this.state.providers, function(provider, index) {
            return <Provider key={provider.id} provider={provider} />
          })
        }
      </div>
    )
  }
})

let Provider = React.createClass({
  render() {
    return(
      <div className="col-md-4">
        <div className="card indigo">
          <div className="card-header">
            <div className="card-title">
              {this.props.provider.state}
              <i className="material-icons"></i>
            </div>
            <i className="fa fa-anchor"></i>
          </div>
          <div className="card-content">{titleize(this.props.provider.name)}</div>
          <div className="card-footer">
            <ProviderAction provider={this.props.provider} />
          </div>
        </div>
      </div>
    )
  }
})

let ProviderAction = React.createClass({
  handleReconnect() {
    channel.push("connections:reconnect", {"provider": this.props.provider.name});
  },
  render() {
    return(
      <div>
        {(() => {
          switch (this.props.provider.state) {
            case "connected":
              return(
                <a className="btn btn-primary" href={`/connection/${this.props.provider.name.toLowerCase()}`}>
                  Connected
                </a>
              );
            case "available":
              return(
                <a className="btn btn-primary" href={`/connection/${this.props.provider.name.toLowerCase()}`}>
                  Connect
                </a>
              );
            case "disconnected":
              return(
                <a className="btn btn-primary" href="#reconnect" onClick={this.handleReconnect}>
                  Reconnect
                </a>
              );
            case "coming_soon":
              return(
                <span>Coming Soon</span>
              );
            case "syncing":
              return(
                <a className="btn btn-primary" href={`/connection/${this.props.provider.name}`}>
                  Syncing
                </a>
              );
          }
        })()}
      </div>
    )
  }
})

if (document.getElementById("providers")) {
  render(<Providers />, document.getElementById("providers"))
}
