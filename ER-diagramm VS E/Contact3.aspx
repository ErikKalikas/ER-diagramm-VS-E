<%@ Page Title="Lisa järjekorda veebivorm" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact3.aspx.vb" Inherits="ER_diagramm_VS_E.Contact3" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Title %></h2>

    <asp:DetailsView ID="DetailsView1" runat="server" AutoGenerateRows="False" DataKeyNames="jarjekord_id"
        DataSourceID="SqlDataSource1_jarjekord" DefaultMode="Insert" Height="50px" Width="400px">
        <Fields>
            <asp:BoundField DataField="jarjekord_id" HeaderText="jarjekord_id" InsertVisible="False" ReadOnly="True" SortExpression="jarjekord_id" />
            <asp:TemplateField HeaderText="laps_id" SortExpression="laps_id">
                <InsertItemTemplate>
                    <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="SqlDataSource1_laps"
                        DataTextField="nimi" DataValueField="laps_id" SelectedValue='<%# Bind("laps_id") %>'>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="SqlDataSource1_laps" runat="server"
                        ConnectionString="<%$ ConnectionStrings:LasteaedConnectionString2 %>"
                        SelectCommand="SELECT laps_id, eesnimi + ' ' + perenimi AS nimi FROM [Laps] ORDER BY perenimi"></asp:SqlDataSource>
                </InsertItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="soovitud_ruhm_id" SortExpression="soovitud_ruhm_id">
                <InsertItemTemplate>
                    <asp:DropDownList ID="DropDownList2" runat="server" DataSourceID="SqlDataSource1_ruhm"
                        DataTextField="nimetus" DataValueField="ruhm_id" SelectedValue='<%# Bind("soovitud_ruhm_id") %>'>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="SqlDataSource1_ruhm" runat="server"
                        ConnectionString="<%$ ConnectionStrings:LasteaedConnectionString2 %>"
                        SelectCommand="SELECT * FROM [Ruhm]"></asp:SqlDataSource>
                </InsertItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="staatus" SortExpression="staatus">
                <InsertItemTemplate>
                    <asp:DropDownList ID="DropDownList3" runat="server" SelectedValue='<%# Bind("staatus") %>'>
                        <asp:ListItem>ootel</asp:ListItem>
                        <asp:ListItem>pakutud</asp:ListItem>
                        <asp:ListItem>vastu võetud</asp:ListItem>
                        <asp:ListItem>tühistatud</asp:ListItem>
                    </asp:DropDownList>
                </InsertItemTemplate>
            </asp:TemplateField>
            <asp:CommandField ShowInsertButton="True" />
        </Fields>
    </asp:DetailsView>

    <asp:SqlDataSource ID="SqlDataSource1_jarjekord" runat="server"
        ConnectionString="<%$ ConnectionStrings:LasteaedConnectionString2 %>"
        SelectCommand="SELECT * FROM [Jarjekord]"
        InsertCommand="INSERT INTO [Jarjekord] ([laps_id], [soovitud_ruhm_id], [staatus]) VALUES (@laps_id, @soovitud_ruhm_id, @staatus)"
        UpdateCommand="UPDATE [Jarjekord] SET [laps_id] = @laps_id, [soovitud_ruhm_id] = @soovitud_ruhm_id, [staatus] = @staatus WHERE [jarjekord_id] = @jarjekord_id"
        DeleteCommand="DELETE FROM [Jarjekord] WHERE [jarjekord_id] = @jarjekord_id">
        <InsertParameters>
            <asp:Parameter Name="laps_id" Type="Int32" />
            <asp:Parameter Name="soovitud_ruhm_id" Type="Int32" />
            <asp:Parameter Name="staatus" Type="String" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="laps_id" Type="Int32" />
            <asp:Parameter Name="soovitud_ruhm_id" Type="Int32" />
            <asp:Parameter Name="staatus" Type="String" />
            <asp:Parameter Name="jarjekord_id" Type="Int32" />
        </UpdateParameters>
        <DeleteParameters>
            <asp:Parameter Name="jarjekord_id" Type="Int32" />
        </DeleteParameters>
    </asp:SqlDataSource>
</asp:Content>
