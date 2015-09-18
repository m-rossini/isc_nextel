/*
 * Copyright (c) 2004-2005 Auster Solutions do Brasil. All Rights Reserved.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; 
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
 * 
 * Created on Aug 5, 2005
 */
package br.com.auster.nextel.xsl.extensions;


/**
 * <p><b>Title:</b> DurationFormat</p>
 * <p><b>Description:</b> TODO class description</p>
 * <p><b>Copyright:</b> Copyright (c) 2004-2005</p>
 * <p><b>Company:</b> Auster Solutions</p>
 *
 * @author rbarone
 * @version $Id: DurationFormat.java,v 1.2 2007/06/04 14:58:01 cfvetuch Exp $
 */
public class DurationFormat extends br.com.auster.common.text.DurationFormat {

  /**
   * Formats the specified duration in minutes to the respective numbers of
   * minutes and seconds.
   * 
   * <p>
   * The resulting String will be in the form:
   * <code>minute + ':' + second</code>
   * 
   * NOTE: precision of all numbers is the same as an Integer (32 bits).
   * 
   * @param durationInMinutes
   *          The duration that will be formatted - must represent a number of
   *          minutes.
   * @return the formatted time in hours, minutes and seconds.
   */
  public static String formatFromMinutes(double durationInMinutes) {
	  int mins = (int) durationInMinutes;
    int secs = (int) Math.round((durationInMinutes - mins) * 60);
    if (secs == 60) {
      mins++;
      secs = 0;
    }
    
    // format using "#,##0"
    final String minutes = String.valueOf(mins);
    final int dots = (int) ((minutes.length() - 1) / 3);
    final int leading = (int) (minutes.length() - (dots * 3));  
    StringBuilder result = new StringBuilder();
    result.append(minutes.substring(0, leading));
    for (int i = 0; i < dots; i++) {
    	result.append('.');
    	final int start = leading + (i * 3);
    	result.append(minutes.substring(start, start + 3));
    }
    
    // Append seconds as ":ss"
    format00(secs, result.append(':'));
    
    return result.toString();
  }

}
