document.addEventListener('turbo:load', ()=>{
  let spinner = document.getElementById("loading");
  spinner.classList.add("loaded");
})
document.addEventListener('turbo:render', ()=>{
  let spinner = document.getElementById("loading");
  spinner.classList.add("loaded");
})