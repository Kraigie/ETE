// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"

let hooks = {
  canvasMini: {
    mounted() {
      let canvas = this.el;
      let ctx = canvas.getContext("2d");
      
      let world = JSON.parse(canvas.dataset.world);
      let players = world.players;

      ctx.clearRect(0, 0, canvas.width, canvas.height)
      for(let player in players) {
        let x = players[player].x / 5
        let y = players[player].y / 5
        let width = players[player].width / 5
        let height = players[player].height / 5
        
        ctx.arc(x, y, width, 0, 2 * Math.PI);
        ctx.stroke();
      }

      Object.assign(this, { canvas, ctx });
    },
    updated() {
      let { canvas, ctx } = this;
      
      let world = JSON.parse(canvas.dataset.world);
      let players = world.players;

      if (this.animationFrameRequest) {
        cancelAnimationFrame(this.animationFrameRequest);
      }

      this.animationFrameRequest = requestAnimationFrame(() => {
        this.animationFrameRequest = undefined;

        ctx.clearRect(0, 0, canvas.width, canvas.height)
        for(let player in players) {
          let x = players[player].x / 3
          let y = players[player].y / 3
          let width = players[player].width / 3
          let height = players[player].height / 3

          ctx.arc(x, y, width, 0, 2 * Math.PI);
          ctx.stroke();
        }
      });
    }
  },
  canvas: {
    mounted() {
      let canvas = this.el;
      let ctx = canvas.getContext("2d");
      
      let world = JSON.parse(canvas.dataset.world);
      let players = world.players;

      ctx.clearRect(0, 0, canvas.width, canvas.height)
      for(let player in players) {
        let x = players[player].x
        let y = players[player].y
        let width = players[player].width
        let height = players[player].height
        
        ctx.arc(x, y, width, 0, 2 * Math.PI);
        ctx.stroke();
      }

      Object.assign(this, { canvas, ctx });
    },
    updated() {
      let { canvas, ctx } = this;
      
      let world = JSON.parse(canvas.dataset.world);
      let players = world.players

      if (this.animationFrameRequest) {
        cancelAnimationFrame(this.animationFrameRequest);
      }

      this.animationFrameRequest = requestAnimationFrame(() => {
        this.animationFrameRequest = undefined;

        ctx.clearRect(0, 0, canvas.width, canvas.height)
        for(let player in players) {
          let x = players[player].x
          let y = players[player].y
          let width = players[player].width
          let height = players[player].height

          ctx.arc(x, y, width, 0, 2 * Math.PI)
          ctx.stroke();
        }
      });
    }
  }
};

let liveSocket = new LiveSocket("/live", Socket, { hooks });
liveSocket.connect();
