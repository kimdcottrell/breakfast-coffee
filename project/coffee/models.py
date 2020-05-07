from django.db import models


class Ingredients(models.Model):
    name = models.CharField(max_length=128, editable=True)
    created_at = models.DateField(auto_now_add=True)
    updated_at = models.DateField(auto_now=True)

    class Meta:
        ordering = ['name']

    def __str__(self):
        return self.name


class Recipe(models.Model):
    name = models.CharField(max_length=255, editable=True)
    description = models.TextField(editable=True)
    instructions = models.TextField(editable=True)
    ingredients = models.ManyToManyField(Ingredients)
    created_at = models.DateField(auto_now_add=True)
    updated_at = models.DateField(auto_now=True)

    class Meta:
        ordering = ['name']

    def __str__(self):
        return self.name
