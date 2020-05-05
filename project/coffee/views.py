from django.shortcuts import render
from django.http import HttpResponse


# Create your views here.

def index(request):
    return HttpResponse("""
    <h1>Welcome to coffee!</h1>
    <ul>
        <li><a href="espresso">espresso</a></li>
        <li><a href="drip">drip</a></li>
    </ul>
    """)


def espresso(request):
    response = HttpResponse("<h1>Welcome to espresso!</h1>")
    response.status_code = 200
    return response


def drip(request):
    return HttpResponse("<h1>Drip coffee is okay too...</h1>")
