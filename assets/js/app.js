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

function doEntityDrawsBig(ctx, entities, show) {
  
  for(let entity in entities) {
    let x = entities[entity].x;
    let y = entities[entity].y;
    let width = entities[entity].width;
    let height = entities[entity].height;

    ctx.drawImage(catMap[entities[entity].avatar], x - width * .25, y - height * .25, height * 1.5, width * 1.5);
    if(show) {
      ctx.beginPath();
      ctx.rect(x, y, width, height);
      ctx.stroke();
    }
  }
}

function doEntityDrawsSmall(ctx, entities) {
  for(let entity in entities) {
    let x = entities[entity].x / 4;
    let y = entities[entity].y / 4;
    let width = entities[entity].width / 4;
    let height = entities[entity].height / 4;
    ctx.drawImage(catMap[entities[entity].avatar], x - width * .25, y - height * .25, height * 1.5, width * 1.5);
  }
}

function draw(canvas, ctx, size) {
  let world = JSON.parse(canvas.dataset.world);
  let player_id = canvas.dataset.id;
  let players = world.players;

  let entities = world.entities;

  ctx.clearRect(0, 0, canvas.width, canvas.height);
  
  if(size == "big"){
    doEntityDrawsBig(ctx, players, players[player_id] ? players[player_id].show_hitboxes : false);
    doEntityDrawsBig(ctx, entities, players[player_id] ? players[player_id].show_hitboxes : false)
  }
  else {
    doEntityDrawsSmall(ctx, players);
    doEntityDrawsSmall(ctx, entities);
  }
}

let hooks = {
  canvasMini: {
    mounted() {
      let canvas = this.el;
      let ctx = canvas.getContext("2d");

      draw(canvas, ctx, "small");

      Object.assign(this, { canvas, ctx });
    },
    updated() {
      let { canvas, ctx } = this;
      
      if (this.animationFrameRequest) {
        cancelAnimationFrame(this.animationFrameRequest);
      }

      this.animationFrameRequest = requestAnimationFrame(() => {
        this.animationFrameRequest = undefined;
        draw(canvas, ctx, "small");
      });
    }
  },
  canvas: {
    mounted() {
      let canvas = this.el;
      let ctx = canvas.getContext("2d");

      draw(canvas, ctx, "big");

      Object.assign(this, { canvas, ctx });
    },
    updated() {
      let { canvas, ctx } = this;
      
      if (this.animationFrameRequest) {
        cancelAnimationFrame(this.animationFrameRequest);
      }

      this.animationFrameRequest = requestAnimationFrame(() => {
        this.animationFrameRequest = undefined;
        draw(canvas, ctx, "big");
      });
    }
  }
};

let liveSocket = new LiveSocket("/live", Socket, { hooks });
liveSocket.connect();
