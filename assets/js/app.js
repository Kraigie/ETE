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

function drawBig(canvas, ctx) {
  let world = JSON.parse(canvas.dataset.world);
  let players = world.players

  ctx.clearRect(0, 0, canvas.width, canvas.height)
  for(let player in players) {
    let x = players[player].x
    let y = players[player].y
    let width = players[player].width
    let height = players[player].height
    ctx.drawImage(catMap[players[player].avatar], x - width * .25, y - height * .25, height * 1.5, width * 1.5)
  }
}

function drawSmall(canvas, ctx) {
  let world = JSON.parse(canvas.dataset.world);
  let players = world.players

  ctx.clearRect(0, 0, canvas.width, canvas.height)
  for(let player in players) {
    let x = players[player].x / 4
    let y = players[player].y / 4
    let width = players[player].width / 4
    let height = players[player].height / 4
    ctx.drawImage(catMap[players[player].avatar], x - width * .25, y - height * .25, height * 1.5, width * 1.5)
  }
}

let hooks = {
  canvasMini: {
    mounted() {
      let canvas = this.el;
      let ctx = canvas.getContext("2d");

      if (this.animationFrameRequest) {
        cancelAnimationFrame(this.animationFrameRequest);
      }

      drawSmall(canvas, ctx);

      Object.assign(this, { canvas, ctx });
    },
    updated() {
      let { canvas, ctx } = this;
      
      if (this.animationFrameRequest) {
        cancelAnimationFrame(this.animationFrameRequest);
      }

      this.animationFrameRequest = requestAnimationFrame(() => {
        this.animationFrameRequest = undefined;
        drawSmall(canvas, ctx);
      });
    }
  },
  canvas: {
    mounted() {
      let canvas = this.el;
      let ctx = canvas.getContext("2d");
      
      drawBig(canvas, ctx);

      Object.assign(this, { canvas, ctx });
    },
    updated() {
      let { canvas, ctx } = this;
      
      if (this.animationFrameRequest) {
        cancelAnimationFrame(this.animationFrameRequest);
      }

      this.animationFrameRequest = requestAnimationFrame(() => {
        this.animationFrameRequest = undefined;
        drawBig(canvas, ctx)
      });
    }
  }
};

let liveSocket = new LiveSocket("/live", Socket, { hooks });
liveSocket.connect();
