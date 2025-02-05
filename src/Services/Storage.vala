/*
* Copyright (c) 2017 Lains
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
*/

namespace jorts {
    public class Storage : Object {
        public string title;
        public string theme;
        public string content;
        public int64 x;
        public int64 y;
        public int64 w;
        public int64 h;


        public Storage() {}

        public Storage.from_storage(string title, string theme, string content, int64 x, int64 y, int64 w, int64 h) {
            this.title = title;
            this.theme = theme;
            this.content = content;
            this.x = x;
            this.y = y;
            this.w = w;
            this.h = h;

        }
    }
}
