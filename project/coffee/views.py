from .models import Recipe
from django.views import generic


class IndexView(generic.ListView):
    def get_queryset(self):
        return Recipe.objects.all()[:5]


class DetailView(generic.DetailView):
    model = Recipe

