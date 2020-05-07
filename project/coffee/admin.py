from django.contrib import admin
from .models import Recipe, Ingredients


@admin.register(Recipe, Ingredients)
class RecipeAdmin(admin.ModelAdmin):
    search_fields = ['name', 'ingredients__name']
