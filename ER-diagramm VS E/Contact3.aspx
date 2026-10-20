<%@ Page Title="Lisa järjekorda veebivorm" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact3.aspx.vb" Inherits="ER_diagramm_VS_E.Contact3" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Title %></h2>

    <asp:DetailsView ID="DetailsView1" runat="server" AutoGenerateRows="False" DataKeyNames="jarjekord_id"
        DataSourceID="SqlDataSource1_jarjekord" DefaultMode="Insert" Height="50px" Width="400px"
        OnItemInserted="DetailsView1_ItemInserted">
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

    <p><asp:Label ID="LabelTeade" runat="server" EnableViewState="False"></asp:Label></p>

    <h3>Järjekord</h3>
    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="jarjekord_id"
        DataSourceID="SqlDataSource1_jarjekord_tabel" CssClass="table"
        OnRowUpdated="GridView1_RowUpdated" OnRowDeleted="GridView1_RowDeleted">
        <Columns>
            <asp:CommandField ShowEditButton="True" ShowDeleteButton="True" />
            <asp:BoundField DataField="jarjekord_id" HeaderText="jarjekord_id" ReadOnly="True" />
            <asp:TemplateField HeaderText="Laps">
                <ItemTemplate>
                    <asp:Label ID="LabelLaps" runat="server" Text='<%# Eval("nimi") %>'></asp:Label>
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:DropDownList ID="DropDownListLaps" runat="server" DataSourceID="SqlDataSource2_laps"
                        DataTextField="nimi" DataValueField="laps_id" SelectedValue='<%# Bind("laps_id") %>'>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="SqlDataSource2_laps" runat="server"
                        ConnectionString="<%$ ConnectionStrings:LasteaedConnectionString2 %>"
                        SelectCommand="SELECT laps_id, eesnimi + ' ' + perenimi AS nimi FROM [Laps] ORDER BY perenimi"></asp:SqlDataSource>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Soovitud rühm">
                <ItemTemplate>
                    <asp:Label ID="LabelRuhm" runat="server" Text='<%# Eval("ruhm") %>'></asp:Label>
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:DropDownList ID="DropDownListRuhm" runat="server" DataSourceID="SqlDataSource2_ruhm"
                        DataTextField="nimetus" DataValueField="ruhm_id" AppendDataBoundItems="True"
                        SelectedValue='<%# Bind("soovitud_ruhm_id") %>'>
                        <asp:ListItem Value="">(pole valitud)</asp:ListItem>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="SqlDataSource2_ruhm" runat="server"
                        ConnectionString="<%$ ConnectionStrings:LasteaedConnectionString2 %>"
                        SelectCommand="SELECT * FROM [Ruhm]"></asp:SqlDataSource>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="lisamise_kp" HeaderText="Lisatud" ReadOnly="True" DataFormatString="{0:dd.MM.yyyy}" />
            <asp:TemplateField HeaderText="Staatus">
                <ItemTemplate>
                    <asp:Label ID="LabelStaatus" runat="server" Text='<%# Eval("staatus") %>'></asp:Label>
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:DropDownList ID="DropDownListStaatus" runat="server" SelectedValue='<%# Bind("staatus") %>'>
                        <asp:ListItem>ootel</asp:ListItem>
                        <asp:ListItem>pakutud</asp:ListItem>
                        <asp:ListItem>vastu võetud</asp:ListItem>
                        <asp:ListItem>tühistatud</asp:ListItem>
                    </asp:DropDownList>
                </EditItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

    <asp:SqlDataSource ID="SqlDataSource1_jarjekord_tabel" runat="server"
        ConnectionString="<%$ ConnectionStrings:LasteaedConnectionString2 %>"
        SelectCommand="SELECT Jarjekord.jarjekord_id, Jarjekord.laps_id, Jarjekord.soovitud_ruhm_id, Laps.eesnimi + ' ' + Laps.perenimi AS nimi, Ruhm.nimetus AS ruhm, Jarjekord.lisamise_kp, Jarjekord.staatus FROM Jarjekord INNER JOIN Laps ON Jarjekord.laps_id = Laps.laps_id LEFT JOIN Ruhm ON Jarjekord.soovitud_ruhm_id = Ruhm.ruhm_id ORDER BY Jarjekord.jarjekord_id"
        UpdateCommand="UPDATE [Jarjekord] SET [laps_id] = @laps_id, [soovitud_ruhm_id] = @soovitud_ruhm_id, [staatus] = @staatus WHERE [jarjekord_id] = @jarjekord_id"
        DeleteCommand="DELETE FROM [Jarjekord] WHERE [jarjekord_id] = @jarjekord_id">
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
