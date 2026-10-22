Imports System

Public Class Contact2
    Inherits Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

    End Sub

    ' Rühma muutmine tabelis
    Protected Sub GridView1_RowUpdated(sender As Object, e As GridViewUpdatedEventArgs)
        If e.Exception IsNot Nothing Then
            LabelTeade.Text = "Viga rühma muutmisel: " & e.Exception.Message
            LabelTeade.ForeColor = System.Drawing.Color.Red
            e.ExceptionHandled = True
            e.KeepInEditMode = True
        Else
            LabelTeade.Text = "Rühm salvestatud!"
            LabelTeade.ForeColor = System.Drawing.Color.Green
        End If
    End Sub

    ' Lapse kustutamine (koos tema rühmade, järjekorra ja puudumistega)
    Protected Sub GridView1_RowDeleted(sender As Object, e As GridViewDeletedEventArgs)
        If e.Exception IsNot Nothing Then
            LabelTeade.Text = "Viga kustutamisel: " & e.Exception.Message
            LabelTeade.ForeColor = System.Drawing.Color.Red
            e.ExceptionHandled = True
        Else
            LabelTeade.Text = "Laps kustutatud."
            LabelTeade.ForeColor = System.Drawing.Color.Green
        End If
    End Sub
End Class
