from django.http import HttpResponse
import requests
from django.shortcuts import render

#from django.shortcuts import render

# Create your views here.

def index(request):
    return HttpResponse("Hello, world. You're at the polls index.")

def home(request):
    response = requests.get('http://localhost:3030/api')
    
    # Verifica que la solicitud fue exitosa
    if response.status_code == 200:
        # Extrae los datos en formato JSON (o el formato que estés usando)
        data = response.json()
    else:
        data = {'error': 'No se pudieron obtener los datos'}

    # Pasa los datos al template
    context = {
        'data': data
    }
    return render(request, 'polls/home.html', context)
