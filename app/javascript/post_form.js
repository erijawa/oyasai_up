// レシピの有無によるフォームの表示/非表示切り替え
const mode = document.getElementById('mode');
const recipeFields = document.getElementById('recipe_fields');
mode.addEventListener('change', (event) => {
    const selectedItem = event.target.value;
    recipeFields.style.display = selectedItem === "10" ? "block" : "none";
});

// 材料フォーム
const ingredientFields = document.getElementById('ingredient_fields');

// 材料フォームの追加
const addIngredientButton = document.getElementById('add_ingredient_button');
addIngredientButton.addEventListener('click', function() {
  ingredientFields.innerHTML += `
    <div class="flex">
        <input name="post_form[ingredients_name][]" placeholder="材料名" class="input input-bordered input-info form-control mb-2 mr-1 w-full mx-auto basis-4/6" type="text" id="post_form_ingredients_name">
        <input name="post_form[ingredients_quantity][]" placeholder="分量" class="input input-bordered input-info form-control mb-2 w-full mx-auto basis-2/6" type="text" id="post_form_ingredients_quantity">
        <button type="button" class="btn btn-ghost delete_button">X</button>
    </div>
  `;
  set_delete_btn_disabled(ingredientFields);
  set_add_btn_disabled();
});

// 材料フォームの削除
ingredientFields.addEventListener('click', (event) => {
  let element = event.target;
  if (element instanceof HTMLButtonElement) {
    element = element.parentNode;
    element.remove();
}
  set_delete_btn_disabled(ingredientFields);
  set_add_btn_disabled();
});

// 削除ボタンの無効化(要素数が1つの場合のみ無効)
function set_delete_btn_disabled(field) {
  let buttons = field.getElementsByClassName('delete_button');
  if (buttons.length == 1) {
    buttons[0].disabled = true;
  }
  else {
    for (i = 0; i < buttons.length; i++) {
      buttons[i].disabled = false;
    }
  }
}

// 追加ボタンの無効化(材料フィールド)
function set_add_btn_disabled() {
  let buttons = ingredientFields.getElementsByClassName('delete_button');
  if (buttons.length < 10) {
    addIngredientButton.disabled = false;
  }
  else {
    addIngredientButton.disabled = true;
  }
}

// 手順フォーム
const stepFields = document.getElementById('step_fields');

// 手順フォームの追加
const addStepButton = document.getElementById('add_step_button');
addStepButton.addEventListener('click', function() {
  let num = stepFields.childElementCount;
  num++;
  stepFields.innerHTML += `
    <div class="flex items-center mb-2">
        <div class="inline w-10 h-10 rounded-full bg-[#8DBA30] text-center leading-10">${num}</div>
        <input name="post_form[steps_instruction][]" class="input input-bordered input-info form-control ml-1 w-full mx-auto inline" type="text" id="post_form_steps_instruction">
        <button type="button" class="btn btn-ghost delete_button">X</button>
    </div>
  `;
  set_delete_btn_disabled(stepFields);
  set_add_step_btn_disabled();
});

// 手順フォームの削除
stepFields.addEventListener('click', (event) => {
  let element = event.target;
  if (element instanceof HTMLButtonElement) {
    element = element.parentNode;
    element.remove();
  }
  let stepForms = stepFields.children;
  for (i = 0; i < stepForms.length; i++) {
    stepForms[i].firstElementChild.innerText = (i + 1);
  }

  set_delete_btn_disabled(stepFields);
  set_add_step_btn_disabled();
});

// 追加ボタンの無効化(手順フィールド)
function set_add_step_btn_disabled() {
  let buttons = stepFields.getElementsByClassName('delete_button');
  if (buttons.length < 8) {
    addStepButton.disabled = false;
  }
  else {
    addStepButton.disabled = true;
  }
}