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
  canvas: {
    mounted() {
      let canvas = this.el;
      let ctx = canvas.getContext("2d");

      console.log("mounted");
      
      Object.assign(this, { canvas, ctx });
    },
    updated() {
      console.log("updated");
      let { canvas, ctx } = this;
      
      let world = JSON.parse(canvas.dataset.world);
      let players = world.players
      console.log(world);


      ctx.clearRect(0, 0, canvas.width, canvas.height)
      for(let player in players) {
        let x = players[player].x
        let y = players[player].y
        let width = players[player].width
        let height = players[player].height
        
        ctx.fillRect(x, y, width, height)
      }
      
      /*
      let halfHeight = canvas.height / 2;
      let halfWidth = canvas.width / 2;
      let smallerHalf = Math.min(halfHeight, halfWidth);
      
      
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      ctx.fillStyle = "rgba(128, 0, 255, 1)";
      ctx.beginPath();
      ctx.arc(
        halfWidth,
        halfHeight,
        smallerHalf / 16,
        0,
        2 * Math.PI
      );
      ctx.fill();
      */
    }
  }
};

let liveSocket = new LiveSocket("/live", Socket, { hooks });
liveSocket.connect();
