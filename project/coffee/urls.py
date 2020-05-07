from django.urls import path
from .views import *

urlpatterns = [
    path('', index),
    path('recipe/<int:recipe_id>/', recipe),
]
