from django.db import models


# Create your models here.
class Ivis(models.Model):
    timestamp = models.DateTimeField(auto_now_add=True, null=False, blank=False)
    mail = models.EmailField(null=False, blank=False)
    ip = models.GenericIPAddressField(null=False, blank=False)
