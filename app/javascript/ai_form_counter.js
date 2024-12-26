const newIngredientNameField = document.querySelector('.new_ingredient_name');
const length = document.querySelector('.length');
const maxLength = 20
newIngredientNameField.addEventListener('input', () => {
  length.textContent = maxLength - newIngredientNameField.value.length;
  if(maxLength - newIngredientNameField.value.length < 0){
    length.style.color = 'red';
  }else{
    length.style.color = '#48350e';
  }
}, false);