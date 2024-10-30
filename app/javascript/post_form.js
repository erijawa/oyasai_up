// レシピの有無によるフォームの表示/非表示切り替え
const mode = document.getElementById('mode');
const recipeFields = document.getElementById('recipe_fields');
mode.addEventListener('change', (event) => {
    const selectedItem = event.target.value;
    recipeFields.style.display = selectedItem === "10" ? "block" : "none";
});