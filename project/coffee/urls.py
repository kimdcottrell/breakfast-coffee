from django.urls import path
from .views import *

urlpatterns = [
    path('', index),
    path('espresso/', espresso),
    path('drip/', drip),
]
