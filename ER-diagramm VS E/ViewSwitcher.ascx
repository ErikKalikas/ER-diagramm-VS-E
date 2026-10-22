<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ViewSwitcher.ascx.vb" Inherits="ER_diagramm_VS_E.ViewSwitcher" %>
<div id="viewSwitcher">
    Vaade: <%: CurrentView %> | <a href="<%: SwitchUrl %>">Vaheta: <%: AlternateView %></a>
</div>
