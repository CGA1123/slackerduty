document.addEventListener('DOMContentLoaded', function () {
  let node = document.getElementsByTagName("slackerduty-elm-main")[0];

  if (node) { Elm.Main.init({ node: node }); }
});
