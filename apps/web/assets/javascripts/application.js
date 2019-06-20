import { Elm } from '../elm/Main.elm'

document.addEventListener('DOMContentLoaded', function () {
  let node = document.getElementsByTagName("slackerduty-elm-main")[0];
  let token = document.getElementsByTagName("html")[0].dataset["csrfToken"]

  if (!node || !token) { return; }

  Elm.Main.init({ node: node, flags: { csrfToken: token } });
});
