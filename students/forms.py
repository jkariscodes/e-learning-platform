from django import forms
from courses.models import Course


class CourseEnrollForm(forms.Form):
    courses = forms.ModelChoiceField(
        queryset=Course.objects.all(), widget=forms.HiddenInput
    )
