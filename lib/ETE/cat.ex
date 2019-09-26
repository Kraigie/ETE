defmodule ETE.Cat do
  @cats %{
    harold: %{
      about: "Kinda ugly but kinda cute? Moved out recently.",
      img: "harold.png",
      name: "Harold"
    },
    hazel: %{
      about: "Doesn't like other cats... or people that much. Used to live with Harold and she's much happier he is gone.",
      img: "hazel.png",
      name: "Hazel"
    },
    jinx: %{
      about: "SMALL, CUTE litle girl. Afraid of everything.",
      img: "jinx.png",
      name: "Jinx"
    },
    karen: %{
      about: "Hellion that everyone hates to love.",
      img: "karen.png",
      name: "Karen"
    },
    kitty: %{
      about: "He lays down when he eats, consumes his weight in food every day, and has the most annoying meow. He's my favorite",
      img: "kitty.png",
      name: "Kitty"
    },
    lucy: %{
      about: "A dog.",
      img: "lucy.png",
      name: "Lucy"
    },
    miz: %{
      about: "Hellion that everyone loves to hate. Recently escaped. Please come back Miz I miss you.",
      img: "miz.png",
      name: "Miz"
    },
    mouse: %{
      about: "Wait a minute...",
      img: "mouse.svg",
      name: "Rat"
    },
    red: %{
      about: "He's a good boy.",
      img: "red.png",
      name: "Red"
    },
    red_chunker: %{
      about: "He's a good ol' chunky boy.",
      img: "red_chunker.png",
      name: "Red"
    },
    red_cone: %{
      about: "Post surgery to remove his boy parts. He says he didn't need them anyways",
      img: "red_cone.png",
      name: "Red"
    }
  }

  def get_cat_map() do
    @cats
  end
end