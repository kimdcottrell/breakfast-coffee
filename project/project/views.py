from django.http import HttpResponse


def hello(request):
    return HttpResponse('<h2>Hello world!</h2>')
