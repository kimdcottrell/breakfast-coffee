from .models import Recipe
from django.shortcuts import render
from django.http import HttpResponse, Http404


def index(request):
    recipes = Recipe.objects.all()
    return render(request, 'index.html', {'recipes': recipes})


def recipe(request, recipe_id):
    try:
        single_recipe = Recipe.objects.get(pk=recipe_id)
    except Recipe.DoesNotExist:
        raise Http404("Recipe does not exist! :(")
    return render(request, 'recipe.html', {'recipe': single_recipe})

