from django.test import TestCase
from typing import List
from .models import Recipe, Ingredients
from django.test import TestCase


def create_or_get_recipe(name: str, description: str, instructions: str, ingredients: List[Ingredients]) -> Recipe:
    recipe_record = Recipe.objects.create(
        name=name,
        description=description,
        instructions=instructions
    )
    # TODO: bulk_create should be a loop of get_or_create
    ingredient_records = Ingredients.objects.bulk_create(ingredients)
    recipe_record.ingredients.set(ingredient_records)
    return recipe_record


class RecipeAndIngredientsModelsTests(TestCase):
    def setUp(self) -> None:
        self.mocha = create_or_get_recipe(
            'Mocha',
            'a drink with some chocolate',
            'drink some chocolate!',
            [
                Ingredients(name='Chocolate'),
                Ingredients(name='Milk'),
                Ingredients(name='Espresso')
            ]
        )
        self.cappuccino = create_or_get_recipe(
            'cappuccino',
            'it is a drink made with 1/3 part milk, 1/3 part milk foam, and 1/3 part espresso',
            'mix it all together',
            [
                Ingredients(name='Milk'),
                Ingredients(name='Espresso')
            ]
        )


class RecipeModelTest(RecipeAndIngredientsModelsTests, TestCase):
    def test_expected_number_of_recipes(self):
        return self.assertEqual(Recipe.objects.count(), 2)


class IngredientsModelTest(RecipeAndIngredientsModelsTests, TestCase):
    def test_expected_number_of_ingredients(self):
        return self.assertEqual(Ingredients.objects.count(), 3)

