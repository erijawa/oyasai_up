document.addEventListener('turbo:load', ()=>{
  const spinner = document.getElementById("loading");
  spinner.classList.add("loaded");
})
document.addEventListener('turbo:render', ()=>{
  const spinner = document.getElementById("loading");
  spinner.classList.add("loaded");
})