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
  let ingredientNameInput = createIngredientNameInput();
  let ingredientQuantityInput = createIngredientQuantityInput();
  let delButton = createDelButton();

  let formArea = document.createElement('div');
  formArea.setAttribute('class', 'flex');
  formArea.appendChild(ingredientNameInput);
  formArea.appendChild(ingredientQuantityInput);
  formArea.appendChild(delButton);

  ingredientFields.appendChild(formArea);

  set_delete_btn_disabled(ingredientFields);
  set_add_btn_disabled();
});
// 材料名フォームの作成
function createIngredientNameInput() {
  let nameInput = document.createElement('input');
  nameInput.setAttribute('type', 'text');
  nameInput.setAttribute('name', 'post_form[ingredients_name][]');
  nameInput.setAttribute('placeholder', '材料名');
  nameInput.setAttribute('class', 'input input-bordered input-info form-control mb-2 mr-1 w-full mx-auto basis-4/6');
  return nameInput;
}
// 材料の分量フォームの作成
function createIngredientQuantityInput() {
  let quantityInput = document.createElement('input');
  quantityInput.setAttribute('type', 'text');
  quantityInput.setAttribute('name', 'post_form[ingredients_quantity][]');
  quantityInput.setAttribute('placeholder', '分量');
  quantityInput.setAttribute('class', 'input input-bordered input-info form-control mb-2 w-full mx-auto basis-2/6');
  return quantityInput;
}
// 削除ボタンの作成
function createDelButton() {
  let delButton = document.createElement('button');
  delButton.setAttribute('type', 'button');
  delButton.setAttribute('class', 'btn btn-ghost delete_button');
  delButton.innerText = "X"
  return delButton;
}

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

  let order = createOrder(num);
  let instructionInput = createInstructionInput();
  let delButton = createDelButton();

  let formArea = document.createElement('div');
  formArea.setAttribute('class', 'flex items-center mb-2');
  formArea.appendChild(order);
  formArea.appendChild(instructionInput);
  formArea.appendChild(delButton);

  stepFields.appendChild(formArea);

  set_delete_btn_disabled(stepFields);
  set_add_step_btn_disabled();
});
// 手順番号の作成
function createOrder(num) {
  let order = document.createElement('div');
  order.setAttribute('class', 'inline w-10 h-10 rounded-full bg-[#8DBA30] text-center leading-10');
  order.innerText = num;
  return order;
}
// 手順フォームの作成
function createInstructionInput() {
  let instructionInput = document.createElement('input');
  instructionInput.setAttribute('type', 'text');
  instructionInput.setAttribute('name', 'post_form[steps_instruction][]');
  instructionInput.setAttribute('placeholder', 'もやしを1分ほどレンジにかける');
  instructionInput.setAttribute('class', 'input input-bordered input-info form-control ml-1 w-full mx-auto inline');
  return instructionInput;
}

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

// タグ入力サポートボタン
const tagInput = document.querySelector('input[name="post_form[tag_names]"]');

// タグをクリックした時の処理
const tagLinks = document.querySelectorAll('.tag-link');
tagLinks.forEach(link => {
  link.addEventListener('click', (e) => {
    // リンクのデフォルト動作を無効化
    e.preventDefault();
    // テキストボックスの内容にタグを追加
    const clickedTag = e.target.innerText.trim();
    if (tagInput.value) {
      tagInput.value = `${tagInput.value},${clickedTag}`;
    } else {
      tagInput.value = `${clickedTag}`;
    }
  });
});